# Recherche bibliographique ciblée

Je veux lancer une recherche bibliographique ciblée pour enrichir mon projet llm-wiki-spatial-data-system.

## Objectif

Trouver environ 200 articles scientifiques qui utilisent ou publient des jeux de données exploitables pour des benchmarks de régression spatiale / économétrie spatiale. Les articles doivent idéalement avoir au moins 5 citations dans le harvest courant et ne pas déjà être présents dans mon corpus local.

## Contexte du projet

- Le projet contient déjà un corpus PDF/BibTeX, un KG, des fiches datasets et un package R spatialtidymodels.
- Les nouveaux articles doivent servir à identifier des jeux de données avec :
  - variable réponse ;
  - covariables ;
  - coordonnées, géométrie ou matrice spatiale W ;
  - formule de régression ou spécification de modèle si disponible ;
  - estimateurs testés ;
  - source de téléchargement des données.

## Périmètre scientifique

Chercher des articles autour de :

- économétrie spatiale ;
- spatial regression ;
- spatial econometrics ;
- SAR, SEM, SDM, SLX ;
- GWR, MGWR, mixed GWR, bandwidth selection ;
- spatially varying coefficients ;
- spatial random forest ;
- geographically weighted random forest ;
- boosting spatial, GWRBoost, gamboost, spboost, CFE ;
- Moran eigenvector maps, ESF, RE-ESF, spmoran ;
- spatial autocorrelation, Moran's I ;
- geospatial machine learning ;
- spatial cross-validation ;
- near prediction / spatial interpolation / spatial prediction.

## Domaines prioritaires

- Airbnb / housing prices / real estate ;
- crime / policing / urban studies ;
- education / income / inequality ;
- health / mortality / epidemiology ;
- agriculture / crop yield / precision agriculture ;
- soil / geochemistry / pollution ;
- climate / precipitation / temperature ;
- transport / mobility ;
- land use / deforestation / biodiversity.

## Critères de sélection

1. Article idéalement avec ≥ 5 citations dans le harvest courant, sauf si article très récent mais central. Le nombre de citations sert à prioriser, pas à rejeter automatiquement un candidat pertinent.
2. Article non déjà présent dans mon corpus local.
3. Article contenant au moins un jeu de données spatial clairement identifiable.
4. Priorité aux articles avec formule, équation, modèle ou liste claire de variables.
5. Ne pas inventer de formule ni de source de données.

## Sources à consulter

- Google Scholar / Semantic Scholar / Crossref / OpenAlex si disponible ;
- sites éditeurs ;
- GitHub, Zenodo, Figshare, Dataverse, Dryad, OSF ;
- documentation R/Python associée ;
- corpus local du projet pour éviter les doublons.

## Sortie attendue

Produire un tableau avec les colonnes suivantes :

- paper_title
- authors
- year
- DOI
- citation_count
- already_in_corpus: yes/no/uncertain
- domain
- estimator_keywords: SAR/SEM/GWR/MGWR/etc.
- dataset_name
- dataset_topic
- dataset_size_if_available
- response_variable
- predictors_or_covariates
- coordinates_or_geometry
- W_or_neighbor_structure_if_available
- regression_formula_or_model_specification
- formula_status: explicit / partial / not_found
- data_access_url
- code_url
- open_access_pdf_url
- reason_for_selection
- ingestion_priority: high / medium / low
- verification_notes

## Méthode

1. Commencer par vérifier les articles déjà présents dans corpus/bib/references.bib et gg/regression_article.bib pour éviter les doublons.
2. Faire la recherche web par blocs de mots-clés et domaines.
3. Pour chaque article candidat, vérifier DOI, citations, dataset, formule et accès aux données.
4. Classer les résultats par priorité d’ingestion.
5. À la fin, proposer les 10 premiers articles à intégrer dans le pipeline GROBID -> KG -> fiches wiki -> spatialtidymodels.

## Important

- Ne pas inventer les citations, formules, DOI ou liens.
- Si une information n’est pas vérifiée, écrire "non vérifié" ou "non trouvé".
- Donner les sources consultées pour chaque article retenu.
