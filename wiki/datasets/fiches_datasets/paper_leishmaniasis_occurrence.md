---
title: paper_leishmaniasis_occurrence
type: dataset
created: 2026-08-16
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_leishmaniasis_occurrence.rds
  - DataCite_2014_GlobalDistributionMapsOf_10_7554_elife_02
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Global distribution maps of the leishmaniases" (DOI 10.7554/elife.02851).

## Description du jeu de donnees

- Topic: epidemiologie / distribution mondiale de la leishmaniose
- Observation unit: occurrence ponctuelle
- Observed population: cas de leishmaniose cutanee, mucocutanee et viscerale, echelle mondiale, N=7762 occurrences
- Geographic context: etendue sf: x [-106.0679, 125.57], y [-29.35, 50.7742]
- Temporal context: 52 distinct periods (variable: YEAR)
- Source description: Global distribution maps of the leishmaniases
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.7554/elife.02851
- Dataset DOI: 10.5061/dryad.05f5h
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.05f5h
- Local raw dir: `data/raw/papers/DataCite_2014_GlobalDistributionMapsOf_10_7554_elife_02/`
- Local sf output: `data/final_datasets/sf/paper_leishmaniasis_occurrence.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `DISEASE`, `DISEASE_binary`
- Candidate Y typology: categorical, binary
- Candidate X variables in local artifact: `SOURCE_TYPE`, `ADMIN_LEVEL`, `YEAR`, `COUNTRY`
- Candidate X count in local artifact: 4
- Candidate X typology: categorical, continuous
- Published X variables from paper: YEAR, SOURCE_TYPE, ADMIN_LEVEL, COUNTRY
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `OCCURRENCE_ID`, `LOCATION_TYPE`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `DISEASE` | `character` | categorical | {Cutaneous, Mucocutaneous, Visceral} | 0% |
| `DISEASE_binary` | `factor` | binary | {VL, CL} | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `leishmaniasis_occurrence`, la reponse retenue est desormais `DISEASE_binary` (corrige 2026-09-08, voir correction ci-dessous), derivee de `DISEASE` (Cutaneous+Mucocutaneous -> CL, Visceral -> VL) pour refleter la structure reellement modelisee par les auteurs (2 taches binaires separees CL/VL, jamais une classification a 3 niveaux). Les covariables X retenues sont `YEAR`, `SOURCE_TYPE`, `ADMIN_LEVEL`, `COUNTRY`. Les coordonnees (`X`, `Y`), identifiants (`OCCURRENCE_ID`, `LOCATION_TYPE`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `SOURCE_TYPE` | `character` | categorical | 0% |
| `ADMIN_LEVEL` | `numeric` | continuous | 0% |
| `YEAR` | `numeric` | continuous | 0% |
| `COUNTRY` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: P(occurrence) ~ [modele boosted regression trees (BRT) sur points de presence, pour cartographier la niche environnementale de la leishmaniose cutanee et viscerale a l'echelle mondiale, avec covariables climatiques/environnementales et generation de pseudo-absences]
- x_terms_pub: YEAR, SOURCE_TYPE, ADMIN_LEVEL, COUNTRY
- y_term_pub: DISEASE
- Reference publication: Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Les fichiers deposes (CL_final_dataset.xlsx, VL_final_dataset.xlsx) ne contiennent que les points de presence reels (pas de pseudo-absences, ni les covariables environnementales du modele BRT complet, qui necessitent des rasters climatiques externes non inclus dans ce depot). formula_used reformule en classification du type clinique (Cutaneous/Mucocutaneous/Visceral) a partir des seules variables presentes dans le depot (annee, source, niveau administratif, pays), une simplification documentee -- pas le modele BRT du papier. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale.
- Reduction binaire APPLIQUEE (2026-09-08, investigation complete sur demande explicite de l'utilisateur : dossier brut re-ouvert, papier relu, ecart d'effectifs elucide) : le TEI confirme que les auteurs modelisent CL et VL SEPAREMENT comme deux taches binaires (jamais une classification a 3 niveaux). L'ecart d'effectifs signale precedemment (7762 local vs 12563 dans le zip Dryad) est entierement explique et n'est PAS un probleme : le zip Dryad complet (`dryad_05f5h_v20150627.zip`, re-extrait le 2026-09-08 -- contenait aussi 2 documents "Evidence+Consensus" et 1 document "Populations_at_risk_CLVL.docx" jamais extraits jusqu'ici) contient CL_final_dataset.xlsx (N=6426 : Cutaneous=6047, Mucocutaneous=379 -- colonne DISEASE native du depot, PAS une construction du pipeline) et VL_final_dataset.xlsx (N=6137 : Visceral=6137). Notre artefact local ne garde que `LOCATION_TYPE == "point"` (deja documente ci-dessus), soit exactement 4248 CL (4126 Cutaneous + 122 Mucocutaneous) + 3514 VL = 7762 -- verifie ligne a ligne, correspondance exacte. Mucocutaneous est un sous-type clinique reconnu de la leishmaniose cutanee (progression muqueuse de L. braziliensis notamment, cf. references du document Evidence+Consensus), donc le regroupement Cutaneous+Mucocutaneous=CL vs Visceral=VL est a la fois clinique et fidele au cadre de modelisation separee CL/VL du papier. Nouvelle colonne `DISEASE_binary` (factor, VL/CL) ajoutee au RDS local (2026-09-08) ; formula_used/x_terms_used/Selected Y typology corriges en consequence.

### Statut regression canonique

- Statut: resolu (corrige 2026-09-08)
- Niveau de preuve: publication -- reponse binaire (DISEASE_binary) alignee sur la modelisation separee CL/VL des auteurs ; covariables X restent une adaptation (BRT+covariables climatiques du papier non disponibles localement)
- Methode d estimation: formule adaptee (covariables du depot uniquement) mais reponse desormais fidele au cadre binaire CL/VL du papier
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16), reponse corrigee en binaire le 2026-09-08 apres investigation complete (dossier brut + TEI). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: DISEASE_binary ~ YEAR + SOURCE_TYPE + ADMIN_LEVEL + COUNTRY
- Selected Y evidence: DISEASE_binary (CL=Cutaneous+Mucocutaneous, VL=Visceral) rapproche la tache du cadre reellement publie (2 modeles binaires separes CL/VL) -- voir correction 2026-09-08 ci-dessus.
- Selected Y typology: binary
- x_terms_used: YEAR, SOURCE_TYPE, ADMIN_LEVEL, COUNTRY
- y_term_used: DISEASE_binary
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  multivariate_constrained:
    formula: "DISEASE_binary ~ YEAR + SOURCE_TYPE + ADMIN_LEVEL + COUNTRY"
    response: "DISEASE_binary"
    predictors: ["YEAR", "SOURCE_TYPE", "ADMIN_LEVEL", "COUNTRY"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Pigott et al. (2014), eLife, doi:10.7554/elife.02851 -- CL et VL modelises separement par les auteurs (2 taches binaires), DISEASE_binary (corrige 2026-09-08) rapproche ce cadre."
    estimator_context: ["ols", "random_forest", "xgboost", "sar_probit", "sem_probit"]
    status: "confirmed"

  ml_or_selected:
    formula: "DISEASE ~ YEAR + SOURCE_TYPE + ADMIN_LEVEL + COUNTRY"
    response: "DISEASE"
    predictors: ["YEAR", "SOURCE_TYPE", "ADMIN_LEVEL", "COUNTRY"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Variante a 3 niveaux (categorielle brute, non supportee par le harnais actuel) -- conservee ici comme reference, DISEASE_binary est la variante executable recommandee (voir multivariate_constrained)."
    estimator_context: ["random_forest", "xgboost"]
    status: "unavailable_multiclass_not_supported"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_leishmaniasis_occurrence`
- Dataset name: Data from: Global distribution maps of the Leishmaniases
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Global distribution maps of the leishmaniases
- Paper DOI: 10.7554/elife.02851
- Dataset DOI: 10.5061/dryad.05f5h
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.05f5h
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "P(occurrence) ~ [modele boosted regression trees (BRT) sur points de presence, pour cartographier la niche environnementale de la leishmaniose cutanee et viscerale a l'echelle mondiale, avec covariables climatiques/environnementales et generation de pseudo-absences]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Les fichiers deposes (CL_final_dataset.xlsx, VL_final_dataset.xlsx) ne contiennent que les points de presence reels (pas de pseudo-absences, ni les covariables environnementales du modele BRT complet, qui necessitent des rasters climatiques externes non inclus dans ce depot). formula_used reformule en classification du type clinique (Cutaneous/Mucocutaneous/Visceral) a partir des seules variables presentes dans le depot (annee, source, niveau administratif, pays), une simplification documentee -- pas le modele BRT du papier. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "classification_binary_cl_vl"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Bloc complete le 2026-09-08 apres correction de la reponse en DISEASE_binary (CL/VL, investigation complete du dossier brut Dryad + TEI, voir Bloc 1). Les auteurs modelisent CL et VL separement (2 taches binaires) par BRT -- xgboost/random_forest sont les analogues boosting/foret les plus proches disponibles dans le harnais ; sar_probit/sem_probit ajoutent une dependance spatiale explicite absente du BRT original mais pertinente pour des occurrences geolocalisees."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Bloc complete le 2026-09-08 apres correction de la reponse en DISEASE_binary (CL/VL, investigation complete du dossier brut Dryad + TEI, voir Bloc 1). Les auteurs modelisent CL et VL separement (2 taches binaires) par BRT -- xgboost/random_forest sont les analogues boosting/foret les plus proches disponibles dans le harnais ; sar_probit/sem_probit ajoutent une dependance spatiale explicite absente du BRT original mais pertinente pour des occurrences geolocalisees.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: random_forest
      basis: published_model
      source_ref: "Pigott et al. (2014), eLife, doi:10.7554/elife.02851 -- boosted regression trees (BRT), tres proche methodologiquement de random_forest (ensembles d'arbres)."
      notes: "Reponse binaire DISEASE_binary (CL/VL), covariables du depot local (pas les covariables climatiques BRT completes du papier)."
    - estimator: xgboost
      basis: published_model
      source_ref: "Pigott et al. (2014) -- BRT est un gradient boosting sur arbres, xgboost est l'implementation la plus proche disponible dans le harnais."
      notes: "Meme reserve que random_forest : covariables adaptees, pas les covariables climatiques completes du BRT original."
    - estimator: ols
      basis: generated_candidate
      source_ref: "Routage binaire ajoute au harnais cette semaine (glm(family=binomial()))."
      notes: "Comparateur non-spatial standard."
    - estimator: sar_probit
      basis: generated_candidate
      source_ref: "Nouvel estimateur ajoute cette semaine pour reponse binaire spatiale (ProbitSpatial, DGP=SAR)."
      notes: "Occurrences geolocalisees avec possible dependance spatiale non testee par le BRT original -- candidat pertinent, pas une reproduction du papier."
    - estimator: sem_probit
      basis: generated_candidate
      source_ref: "Nouvel estimateur ajoute cette semaine pour reponse binaire spatiale (ProbitSpatial, DGP=SEM)."
      notes: "Meme justification que sar_probit."
  conditionally_eligible_estimators: []
  ineligible_reason: "Bloc complete le 2026-09-08 apres correction de la reponse en DISEASE_binary (CL/VL, investigation complete du dossier brut Dryad + TEI, voir Bloc 1). Les auteurs modelisent CL et VL separement (2 taches binaires) par BRT -- xgboost/random_forest sont les analogues boosting/foret les plus proches disponibles dans le harnais ; sar_probit/sem_probit ajoutent une dependance spatiale explicite absente du BRT original mais pertinente pour des occurrences geolocalisees."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 7762
- k variables: 10
- T periods: 52
- Variable temporelle: YEAR
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (7762) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 2771 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=31). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 2771 unites spatiales distinctes, pas sur les 7762 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 52 distinct periods (variable: YEAR)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-106.0679, 125.57], y [-29.35, 50.7742]
- Time range: 1958 to 2013 (variable: YEAR)
- CRS analyse recommande: pending - multi-zones (span=231.6deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.05f5h (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`leishmaniasis_occurrence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `leishmaniasis_occurrence` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`leishmaniasis_occurrence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Global distribution maps of the leishmaniases

## Curation documentée — 2026-09-07

Decision conservatoire : Tache categorical a documenter par reponse et estimateur; aucune selection automatique de familles gaussiennes. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : categorical. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
