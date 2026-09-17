---
title: Python_geodatasets_geoda.police
type: dataset
created: 2026-08-15
updated: 2026-09-17
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.police.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`police`).

## Description du jeu de donnees

- Topic: criminalite urbaine
- Observation unit: quartier, zone urbaine ou evenement de police selon la documentation source
- Observed population: unites spatiales ou evenements lies a la criminalite
- Geographic context: Etendue mesuree dans le RDS : x [-91.331431669259, -88.221578668756], y [30.42252065, 34.9319592]; CRS WGS 84.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`police`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `CRIME`, `POLICE`
- Candidate Y typology: count
- Candidate X variables: `POP`, `INC`, `UNEMP`, `OWN`, `COLLEGE`, `WHITE`, `COMMUTE`, `TAX`, `TRANSFER`, `AREA`, `PERIMETER`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `CNTY_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown
- Note complementaire (2026-09-17) : VERIFICATION DIRECTE (2026-09-17) : ajustement de la formule exacte (POLICE ~ TAX+TRANSFER+INC+CRIME+UNEMP+OWN+COLLEGE+WHITE+COMMUTE) sur ce .rds local (N=82, confirme identique). Resultat : TAX=0.218, TRANSFER=0.0755, INC=0.103, CRIME=1.331, UNEMP=-19.90, OWN=-7.929, COLLEGE=-0.369, WHITE=-0.341, COMMUTE=3.27 ; R2=0.971 -- ORDRES DE GRANDEUR TRES DIFFERENTS des coefficients publies (TAX x9, TRANSFER x68, CRIME x156, R2 0.78 vs 0.97). Ce n'est PAS un simple facteur d'echelle uniforme (les ratios different d'une variable a l'autre) -- le jeu geodatasets::police distribue aujourd'hui n'est probablement pas identique (unites, annee ou definitions de variables) aux donnees exactes analysees par Kelejian & Robinson en 1992, meme s'il provient de la meme source (comtes du Mississippi, memes noms de variables, N=82 identique). N'INVENTER aucune explication precise sans verification supplementaire du codebook exact -- la formule et la liste de variables sont authentiques et sourcees, mais la reproduction numerique sur cet artefact n'est PAS confirmee (contrairement a paper_medicago ou R_SpatialEpi_pennLC_sf_pennLC_sf ou la reproduction a reussi).

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CRIME` | `integer` | count | [5, 1739] | 0% |
| `POLICE` | `integer` | count | [49, 10971] | 0% |


> Selection Y/X (claude-sonnet-4-6) : CRIME (nombre de crimes) et POLICE (effectifs policiers) sont les variables réponses naturelles dans un dataset 'police' à vocation criminologique/sécuritaire. Les variables socio-économiques (INC, UNEMP, OWN, COLLEGE, WHITE, COMMUTE, TAX, TRANSFER), démographiques (POP) et morphologiques (AREA, PERIMETER) constituent des covariables explicatives pertinentes ; les codes FIPS, noms et identifiants administratifs sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP` | `integer` | count | 0% |
| `INC` | `integer` | count | 0% |
| `UNEMP` | `integer` | count | 0% |
| `OWN` | `integer` | count | 0% |
| `COLLEGE` | `integer` | count | 0% |
| `WHITE` | `integer` | count | 0% |
| `COMMUTE` | `integer` | count | 0% |
| `TAX` | `integer` | count | 0% |
| `TRANSFER` | `integer` | count | 0% |
| `AREA` | `numeric` | rate | 0% |
| `PERIMETER` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: POLICE ~ TAX + TRANSFER + INC + CRIME + UNEMP + OWN + COLLEGE + WHITE + COMMUTE
- x_terms_pub: TAX, TRANSFER, INC, CRIME, UNEMP, OWN, COLLEGE, WHITE, COMMUTE
- y_term_pub: POLICE (police expenditures per capita, 1982, comtes du Mississippi)
- Reference publication: Kelejian, H.H. & Robinson, D.P. (1992), 'Spatial autocorrelation: A new computationally simple test with an application to per capita county police expenditures', Regional Science and Urban Economics 22(3), 317-331, DOI 10.1016/0166-0462(92)90032-V (texte integral verifie via corpus/papers/tei/A new computationally simple test with an application to police dataset.tei.xml, deja disponible localement). Modele complet (eq. 11, section 5), N=82 comtes du Mississippi, 1982 : POLi = a0 + a1*Taxi + a2*Transi + a3*Inci + a4*Crimei + a5*Unempi + a6*Owneri + a7*Collegei + a8*Whitei + a9*Outi + ui (Out = pourcentage de commuters, correspond a COMMUTE dans cet artefact). Resultats OLS publies (eq. 12, coefficients puis t-statistiques entre parentheses) : POL_hat = 32.1988 + 0.0237*Tax (3.465) + 0.0011*Trans (0.325) + 0.0033*Inc (4.925) + 0.0085*Crime (3.719) - 0.7378*Unemp (2.912) - 0.2729*Own (3.415) - 0.0455*College (0.845) - 0.1549*White (4.242) - 0.0808*Out (1.898) ; R2=0.78, sigma2=15.2325. Modele tronque alternatif (eq. 13-14) : POLi = a0 + a1*Taxi + a2*Transi + a3*Inci + vi -> POL_hat = -3.4640 + 0.0446*Tax (4.859) - 0.0020*Trans (0.431) + 0.0032*Inc (4.490) ; R2=0.46. L'objectif du papier est un test d'autocorrelation spatiale des residus (methode de Kelejian-Robinson), pas la regression elle-meme -- le modele sert d'illustration.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee ; coefficients publies documentes, mais NON reproduits par ajustement direct sur cet artefact (voir note)
- Correspondance Python/R: aucune identifiee
- Note: VERIFICATION DIRECTE (2026-09-17) : ajustement de la formule exacte (POLICE ~ TAX+TRANSFER+INC+CRIME+UNEMP+OWN+COLLEGE+WHITE+COMMUTE) sur ce .rds local (N=82, confirme identique). Resultat : TAX=0.218, TRANSFER=0.0755, INC=0.103, CRIME=1.331, UNEMP=-19.90, OWN=-7.929, COLLEGE=-0.369, WHITE=-0.341, COMMUTE=3.27 ; R2=0.971 -- ORDRES DE GRANDEUR TRES DIFFERENTS des coefficients publies (TAX x9, TRANSFER x68, CRIME x156, R2 0.78 vs 0.97). Ce n'est PAS un simple facteur d'echelle uniforme (les ratios different d'une variable a l'autre) -- le jeu geodatasets::police distribue aujourd'hui n'est probablement pas identique (unites, annee ou definitions de variables) aux donnees exactes analysees par Kelejian & Robinson en 1992, meme s'il provient de la meme source (comtes du Mississippi, memes noms de variables, N=82 identique). N'INVENTER aucune explication precise sans verification supplementaire du codebook exact -- la formule et la liste de variables sont authentiques et sourcees, mais la reproduction numerique sur cet artefact n'est PAS confirmee (contrairement a paper_medicago ou R_SpatialEpi_pennLC_sf_pennLC_sf ou la reproduction a reussi).

### Formule — niveau systeme

- formula_used: POLICE ~ TAX + TRANSFER + INC + CRIME + UNEMP + OWN + COLLEGE + WHITE + COMMUTE
- Formula used evidence: formula_pub confirmee (Kelejian & Robinson 1992) -- promue en formula_used car variables et reponse identiques a l'artefact local, meme si les coefficients numeriques publies ne se reproduisent pas exactement ici (voir Statut regression canonique).
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: TAX, TRANSFER, INC, CRIME, UNEMP, OWN, COLLEGE, WHITE, COMMUTE
- y_term_used: POLICE

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "POLICE ~ TAX + TRANSFER + INC"
    response: "POLICE"
    predictors: ["TAX", "TRANSFER", "INC"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Kelejian, H.H. & Robinson, D.P. (1992), 'Spatial autocorrelation: A new computationally simple test with an application to per capita county police expenditures', Regional Science and Urban Economics 22(3), 317-331, DOI 10.1016/0166-0462(92)90032-V (texte integral verifie via corpus/papers/tei/A new computationally simple test with an application to police dataset.tei.xml, deja disponible localement). Modele complet (eq. 11, section 5), N=82 comtes du Mississippi, 1982 : POLi = a0 + a1*Taxi + a2*Transi + a3*Inci + a4*Crimei + a5*Unempi + a6*Owneri + a7*Collegei + a8*Whitei + a9*Outi + ui (Out = pourcentage de commuters, correspond a COMMUTE dans cet artefact). Resultats OLS publies (eq. 12, coefficients puis t-statistiques entre parentheses) : POL_hat = 32.1988 + 0.0237*Tax (3.465) + 0.0011*Trans (0.325) + 0.0033*Inc (4.925) + 0.0085*Crime (3.719) - 0.7378*Unemp (2.912) - 0.2729*Own (3.415) - 0.0455*College (0.845) - 0.1549*White (4.242) - 0.0808*Out (1.898) ; R2=0.78, sigma2=15.2325. Modele tronque alternatif (eq. 13-14) : POLi = a0 + a1*Taxi + a2*Transi + a3*Inci + vi -> POL_hat = -3.4640 + 0.0446*Tax (4.859) - 0.0020*Trans (0.431) + 0.0032*Inc (4.490) ; R2=0.46. L'objectif du papier est un test d'autocorrelation spatiale des residus (methode de Kelejian-Robinson), pas la regression elle-meme -- le modele sert d'illustration. Modele tronque (eq. 13-14) : R2=0.46."
    estimator_context: ["ols"]
    status: "confirmed"

  multivariate_constrained:
    formula: "POLICE ~ TAX + TRANSFER + INC + CRIME + UNEMP + OWN + COLLEGE + WHITE + COMMUTE"
    response: "POLICE"
    predictors: ["TAX", "TRANSFER", "INC", "CRIME", "UNEMP", "OWN", "COLLEGE", "WHITE", "COMMUTE"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Kelejian, H.H. & Robinson, D.P. (1992), 'Spatial autocorrelation: A new computationally simple test with an application to per capita county police expenditures', Regional Science and Urban Economics 22(3), 317-331, DOI 10.1016/0166-0462(92)90032-V (texte integral verifie via corpus/papers/tei/A new computationally simple test with an application to police dataset.tei.xml, deja disponible localement). Modele complet (eq. 11, section 5), N=82 comtes du Mississippi, 1982 : POLi = a0 + a1*Taxi + a2*Transi + a3*Inci + a4*Crimei + a5*Unempi + a6*Owneri + a7*Collegei + a8*Whitei + a9*Outi + ui (Out = pourcentage de commuters, correspond a COMMUTE dans cet artefact). Resultats OLS publies (eq. 12, coefficients puis t-statistiques entre parentheses) : POL_hat = 32.1988 + 0.0237*Tax (3.465) + 0.0011*Trans (0.325) + 0.0033*Inc (4.925) + 0.0085*Crime (3.719) - 0.7378*Unemp (2.912) - 0.2729*Own (3.415) - 0.0455*College (0.845) - 0.1549*White (4.242) - 0.0808*Out (1.898) ; R2=0.78, sigma2=15.2325. Modele tronque alternatif (eq. 13-14) : POLi = a0 + a1*Taxi + a2*Transi + a3*Inci + vi -> POL_hat = -3.4640 + 0.0446*Tax (4.859) - 0.0020*Trans (0.431) + 0.0032*Inc (4.490) ; R2=0.46. L'objectif du papier est un test d'autocorrelation spatiale des residus (methode de Kelejian-Robinson), pas la regression elle-meme -- le modele sert d'illustration."
    estimator_context: ["ols"]
    status: "confirmed"
    note: "VERIFICATION DIRECTE (2026-09-17) : ajustement de la formule exacte (POLICE ~ TAX+TRANSFER+INC+CRIME+UNEMP+OWN+COLLEGE+WHITE+COMMUTE) sur ce .rds local (N=82, confirme identique). Resultat : TAX=0.218, TRANSFER=0.0755, INC=0.103, CRIME=1.331, UNEMP=-19.90, OWN=-7.929, COLLEGE=-0.369, WHITE=-0.341, COMMUTE=3.27 ; R2=0.971 -- ORDRES DE GRANDEUR TRES DIFFERENTS des coefficients publies (TAX x9, TRANSFER x68, CRIME x156, R2 0.78 vs 0.97). Ce n'est PAS un simple facteur d'echelle uniforme (les ratios different d'une variable a l'autre) -- le jeu geodatasets::police distribue aujourd'hui n'est probablement pas identique (unites, annee ou definitions de variables) aux donnees exactes analysees par Kelejian & Robinson en 1992, meme s'il provient de la meme source (comtes du Mississippi, memes noms de variables, N=82 identique). N'INVENTER aucune explication precise sans verification supplementaire du codebook exact -- la formule et la liste de variables sont authentiques et sourcees, mais la reproduction numerique sur cet artefact n'est PAS confirmee (contrairement a paper_medicago ou R_SpatialEpi_pennLC_sf_pennLC_sf ou la reproduction a reussi)."

  ml_or_selected:
    formula: "POLICE ~ POP + INC + UNEMP + OWN + COLLEGE + WHITE + COMMUTE + TAX + TRANSFER + AREA + PERIMETER"
    response: "POLICE"
    predictors: ["POP", "INC", "UNEMP", "OWN", "COLLEGE", "WHITE", "COMMUTE", "TAX", "TRANSFER", "AREA", "PERIMETER"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Ajoute le 2026-09-17 (nouvelle pratique standard pour les fiches a plus de 10 X : proposer une formule ML/boosting exploitant toutes les covariables disponibles pour selection automatique). Toutes les variables sont exogenes (socio-economiques/demographiques/morphologiques), aucune fuite de la reponse identifiee. CRIME exclu car candidat Y alternatif, pas un X."
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.police`
- Dataset name: geodatasets::police
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression lineaire multiple (OLS) sur donnees geolocalisees
- Modele niveau 2 (famille): regression lineaire descriptive (pas de modele spatial explicite ajuste -- le papier propose un TEST d'autocorrelation spatiale des residus, pas un estimateur spatial)
- Modele niveau 3 (variante): modele complet (9 predicteurs) et modele tronque (3 predicteurs), compares via le test de Kelejian-Robinson

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "POLICE ~ TAX + TRANSFER + INC + CRIME + UNEMP + OWN + COLLEGE + WHITE + COMMUTE [OLS]"
  equation_family: linear_regression_descriptive
  model_family: "OLS descriptif -- formule et coefficients publies documentes, reproduction numerique locale NON confirmee (voir note)"
  source_type: scientific_publication
  source_ref: "Kelejian, H.H. & Robinson, D.P. (1992), 'Spatial autocorrelation: A new computationally simple test with an application to per capita county police expenditures', Regional Science and Urban Economics 22(3), 317-331, DOI 10.1016/0166-0462(92)90032-V (texte integral verifie via corpus/papers/tei/A new computationally simple test with an application to police dataset.tei.xml, deja disponible localement). Modele complet (eq. 11, section 5), N=82 comtes du Mississippi, 1982 : POLi = a0 + a1*Taxi + a2*Transi + a3*Inci + a4*Crimei + a5*Unempi + a6*Owneri + a7*Collegei + a8*Whitei + a9*Outi + ui (Out = pourcentage de commuters, correspond a COMMUTE dans cet artefact). Resultats OLS publies (eq. 12, coefficients puis t-statistiques entre parentheses) : POL_hat = 32.1988 + 0.0237*Tax (3.465) + 0.0011*Trans (0.325) + 0.0033*Inc (4.925) + 0.0085*Crime (3.719) - 0.7378*Unemp (2.912) - 0.2729*Own (3.415) - 0.0455*College (0.845) - 0.1549*White (4.242) - 0.0808*Out (1.898) ; R2=0.78, sigma2=15.2325. Modele tronque alternatif (eq. 13-14) : POLi = a0 + a1*Taxi + a2*Transi + a3*Inci + vi -> POL_hat = -3.4640 + 0.0446*Tax (4.859) - 0.0020*Trans (0.431) + 0.0032*Inc (4.490) ; R2=0.46. L'objectif du papier est un test d'autocorrelation spatiale des residus (methode de Kelejian-Robinson), pas la regression elle-meme -- le modele sert d'illustration. VERIFICATION DIRECTE (2026-09-17) : ajustement de la formule exacte (POLICE ~ TAX+TRANSFER+INC+CRIME+UNEMP+OWN+COLLEGE+WHITE+COMMUTE) sur ce .rds local (N=82, confirme identique). Resultat : TAX=0.218, TRANSFER=0.0755, INC=0.103, CRIME=1.331, UNEMP=-19.90, OWN=-7.929, COLLEGE=-0.369, WHITE=-0.341, COMMUTE=3.27 ; R2=0.971 -- ORDRES DE GRANDEUR TRES DIFFERENTS des coefficients publies (TAX x9, TRANSFER x68, CRIME x156, R2 0.78 vs 0.97). Ce n'est PAS un simple facteur d'echelle uniforme (les ratios different d'une variable a l'autre) -- le jeu geodatasets::police distribue aujourd'hui n'est probablement pas identique (unites, annee ou definitions de variables) aux donnees exactes analysees par Kelejian & Robinson en 1992, meme s'il provient de la meme source (comtes du Mississippi, memes noms de variables, N=82 identique). N'INVENTER aucune explication precise sans verification supplementaire du codebook exact -- la formule et la liste de variables sont authentiques et sourcees, mais la reproduction numerique sur cet artefact n'est PAS confirmee (contrairement a paper_medicago ou R_SpatialEpi_pennLC_sf_pennLC_sf ou la reproduction a reussi)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 82
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-91.3314, -88.2216], y [30.4225, 34.932] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : POLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32616 (UTM Zone 16N (EPSG:32616)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "regression_spatial_published_formula_unverified_fit"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Formule publiee identifiee et confirmee (Kelejian & Robinson 1992, DOI verifie, texte integral lu localement) le 2026-09-17. package_include reste 'manual_review' (pas 'yes') car la reproduction numerique sur cet artefact echoue (coefficients tres differents des valeurs publiees, voir Estimator eligibility) -- le jeu distribue aujourd'hui n'est vraisemblablement pas identique aux donnees exactes de 1982. Formule et variables restent neanmoins authentiques et documentees ; revue manuelle requise avant toute promotion."
  reason: "Formule publiee identifiee et confirmee (Kelejian & Robinson 1992, DOI verifie, texte integral lu localement) le 2026-09-17. package_include reste 'manual_review' (pas 'yes') car la reproduction numerique sur cet artefact echoue (coefficients tres differents des valeurs publiees, voir Estimator eligibility) -- le jeu distribue aujourd'hui n'est vraisemblablement pas identique aux donnees exactes de 1982. Formule et variables restent neanmoins authentiques et documentees ; revue manuelle requise avant toute promotion."
```

- Decision: manual_review
- Manque principal: Formule publiee identifiee et confirmee (Kelejian & Robinson 1992, DOI verifie, texte integral lu localement) le 2026-09-17. package_include reste 'manual_review' (pas 'yes') car la reproduction numerique sur cet artefact echoue (coefficients tres differents des valeurs publiees, voir Estimator eligibility) -- le jeu distribue aujourd'hui n'est vraisemblablement pas identique aux donnees exactes de 1982. Formule et variables restent neanmoins authentiques et documentees ; revue manuelle requise avant toute promotion.
- Raison: Formule publiee identifiee et confirmee (Kelejian & Robinson 1992, DOI verifie, texte integral lu localement) le 2026-09-17. package_include reste 'manual_review' (pas 'yes') car la reproduction numerique sur cet artefact echoue (coefficients tres differents des valeurs publiees, voir Estimator eligibility) -- le jeu distribue aujourd'hui n'est vraisemblablement pas identique aux donnees exactes de 1982. Formule et variables restent neanmoins authentiques et documentees ; revue manuelle requise avant toute promotion.

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators:
    - estimator: ols
      basis: published_model
      source_ref: "Kelejian, H.H. & Robinson, D.P. (1992), 'Spatial autocorrelation: A new computationally simple test with an application to per capita county police expenditures', Regional Science and Urban Economics 22(3), 317-331, DOI 10.1016/0166-0462(92)90032-V (texte integral verifie via corpus/papers/tei/A new computationally simple test with an application to police dataset.tei.xml, deja disponible localement)."
      notes: "Formule et liste de variables confirmees exactement (eq. 11-12, N=82 identique). ATTENTION : l'ajustement direct de cette formule sur ce .rds ne reproduit PAS les coefficients publies (ecarts de x9 a x156 selon la variable, R2 0.78 publie vs 0.97 obtenu localement) -- voir la note detaillee dans Formules candidates > multivariate_constrained. Le jeu geodatasets::police distribue aujourd'hui n'est vraisemblablement pas identique aux donnees exactes de 1982 analysees par les auteurs (unites/definitions/annee possiblement differentes), meme s'il partage les memes noms de variables et le meme N."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- ols eligible avec preuve publiee directe, mais avec la reserve explicite ci-dessus sur la non-reproduction numerique."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Curation documentée — 2026-09-17

Recherche du 2026-09-17 (suite a un echange avec un autre agent IA ayant identifie Kelejian & Robinson 1992) : DOI verifie via Crossref, texte integral deja disponible localement (corpus/papers/tei/A new computationally simple test with an application to police dataset.tei.xml) et lu en entier -- la reference de ChatGPT etait exacte, et j'ai retrouve l'equation COMPLETE (celle recuperee par ChatGPT etait tronquee avant le dernier coefficient, COMMUTE).

VERIFICATION DIRECTE (2026-09-17) : ajustement de la formule exacte (POLICE ~ TAX+TRANSFER+INC+CRIME+UNEMP+OWN+COLLEGE+WHITE+COMMUTE) sur ce .rds local (N=82, confirme identique). Resultat : TAX=0.218, TRANSFER=0.0755, INC=0.103, CRIME=1.331, UNEMP=-19.90, OWN=-7.929, COLLEGE=-0.369, WHITE=-0.341, COMMUTE=3.27 ; R2=0.971 -- ORDRES DE GRANDEUR TRES DIFFERENTS des coefficients publies (TAX x9, TRANSFER x68, CRIME x156, R2 0.78 vs 0.97). Ce n'est PAS un simple facteur d'echelle uniforme (les ratios different d'une variable a l'autre) -- le jeu geodatasets::police distribue aujourd'hui n'est probablement pas identique (unites, annee ou definitions de variables) aux donnees exactes analysees par Kelejian & Robinson en 1992, meme s'il provient de la meme source (comtes du Mississippi, memes noms de variables, N=82 identique). N'INVENTER aucune explication precise sans verification supplementaire du codebook exact -- la formule et la liste de variables sont authentiques et sourcees, mais la reproduction numerique sur cet artefact n'est PAS confirmee (contrairement a paper_medicago ou R_SpatialEpi_pennLC_sf_pennLC_sf ou la reproduction a reussi).

Cette fiche illustre l'importance de verifier une "reproduction" annoncee par un autre agent avant de la considerer comme une preuve : les chiffres que ChatGPT avait presentes comme "une reproduction OLS" (POL_hat = -485.8 + 0.2182*TAX + ...) correspondent en realite exactement a un ajustement sur les donnees geodatasets modernes (verifie : ce sont les memes valeurs a la decimale pres que mon propre ajustement local), pas aux vraies valeurs publiees par Kelejian & Robinson en 1992 -- une confusion entre "reproduction du papier" et "ajustement sur un jeu de donnees portant le meme nom mais possiblement different".
