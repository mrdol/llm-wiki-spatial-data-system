---
title: paper_portugal_covid_municipal
type: dataset
created: 2026-09-14
updated: 2026-09-16
sources:
  - data/final_datasets/sf/paper_portugal_covid_municipal.rds
  - DatasetFirst_10_5281_zenodo_11222023
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial correlates of COVID-19 first wave across continental Portugal" (DOI 10.4081/gh.2022.1073).

## Description du jeu de donnees

- Topic: epidemiologie spatiale / covid-19 au niveau municipal
- Observation unit: concelho portugais x jour
- Observed population: concelhos du Portugal (298/308 apparies), panel journalier DGS, N=20604
- Geographic context: Etendue mesuree dans le RDS : x [-31.229752696287, -6.310955346792], y [32.68701355, 42.0597907]; CRS WGS 84.
- Temporal context: 68 distinct periods (variable: data)
- Source description: Spatial correlates of COVID-19 first wave across continental Portugal
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.4081/gh.2022.1073
- Dataset DOI: 10.5281/zenodo.11222023
- Source URL: https://doi.org/10.5281/zenodo.11222023
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_11222023/`
- Local sf output: `data/final_datasets/sf/paper_portugal_covid_municipal.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `incidencia`
- Candidate Y typology: unknown
- Candidate X variables in local artifact: `data`, `confirmados_14`, `confirmados_1`, `incidencia_categoria`, `incidencia_risco`, `tendencia_incidencia`, `tendencia_categoria`, `tendencia_desc`, `casos_14dias`, `area`, `population`, `population_65_69`, `population_70_74`, `population_75_79`, `population_80_84`, `population_85_mais`, `population_80_mais`, `population_75_mais`, `population_70_mais`, `population_65_mais`, `densidade_populacional`, `densidade_1`, `densidade_2`, `densidade_3`
- Candidate X count in local artifact: 24
- Candidate X typology: categorical, unknown, continuous
- Published X variables from paper: population (population totale du concelho), densidade_populacional (densite de population, hab/km2) -- confirmee dans la categorie 'Population' des 33 variables candidates du papier
- Published X count: 2
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `key`, `shapeName`, `concelho`, `dicofre`, `distrito`, `ars`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `incidencia` | `integer` | count | [0, 11918] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `portugal_covid_municipal`, la ou les reponses `incidencia` viennent du loader papier et/ou des preuves de l article `Spatial correlates of COVID-19 first wave across continental Portugal`. Les covariables X retenues sont `population`, `densidade_populacional` ; 22 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`key`, `shapeName`, `concelho`, `dicofre`, `distrito`, `ars`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `data` | `character` | categorical | 0% |
| `confirmados_14` | `integer` | unknown | 0% |
| `confirmados_1` | `integer` | unknown | 0% |
| `incidencia_categoria` | `character` | categorical | 0% |
| `incidencia_risco` | `character` | categorical | 0% |
| `tendencia_incidencia` | `numeric` | continuous | 97.1% |
| `tendencia_categoria` | `character` | categorical | 0% |
| `tendencia_desc` | `character` | categorical | 0% |
| `casos_14dias` | `integer` | unknown | 0% |
| `area` | `numeric` | continuous | 0% |
| `population` | `integer` | unknown | 0% |
| `population_65_69` | `integer` | unknown | 0% |
| `population_70_74` | `integer` | unknown | 0% |
| `population_75_79` | `integer` | unknown | 0% |
| `population_80_84` | `integer` | unknown | 0% |
| `population_85_mais` | `integer` | unknown | 0% |
| `population_80_mais` | `integer` | unknown | 0% |
| `population_75_mais` | `integer` | unknown | 0% |
| `population_70_mais` | `integer` | unknown | 0% |
| `population_65_mais` | `integer` | unknown | 0% |
| `densidade_populacional` | `numeric` | continuous | 0% |
| `densidade_1` | `numeric` | continuous | 0% |
| `densidade_2` | `numeric` | continuous | 0% |
| `densidade_3` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: log(cases_per_10k_15days) ~ pct_emploi_services + temps_trajet_moyen_individuel + pct_emploi_agricole + taille_moyenne_famille + [12 autres variables retenues sur 33 candidates, VIF<2.5] [Barbosa, Silva, Capinha, Garcia & Rocha (2022), 'Spatial correlates of COVID-19 first wave across continental Portugal', Geospatial Health 17(s1):1073, doi:10.4081/gh.2022.1073, texte integral lu (PDF telecharge depuis repositorio.ulisboa.pt, licence CC-BY-NC 4.0). GLMM distribution Tweedie avec effet aleatoire NUTS-3, sur N=278 municipalites (Portugal continental, Acores/Madere exclus faute de donnees), 12 modeles separes (un par periode de 15 jours, avril-septembre 2020). 33 variables candidates en 6 categories (population, socio-economique, habitat, mobilite, sante, environnement -- source principale INE/Statistics Portugal + E-OBS pour temperature/precipitation), reduites a 16 apres diagnostic de multicollinearite (VIF>2.5 retire)]
- x_terms_pub: population (population totale du concelho), densidade_populacional (densite de population, hab/km2) -- confirmee dans la categorie 'Population' des 33 variables candidates du papier
- y_term_pub: incidencia (taux d'incidence COVID-19 standardise sur 14 jours, par concelho) -- le papier utilise en realite le nombre de cas par periode de 15 jours, converti en incidence pour 10000 habitants, log-transforme
- Reference publication: REVISE x2 (session 2026-08-16 ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : (1) papier trouve et confirme -- Barbosa, Silva, Capinha, Garcia & Rocha (2022), 'Spatial correlates of COVID-19 first wave across continental Portugal', Geospatial Health 17(s1):1073, doi:10.4081/gh.2022.1073. (2) TEXTE INTEGRAL LU (recherche web demandee par l'utilisateur, PDF en libre acces telecharge depuis le depot institutionnel repositorio.ulisboa.pt, CC-BY-NC 4.0) : etude sur N=278 municipalites du Portugal continental (Acores et Madere exclus, donnees indisponibles pour plusieurs variables explicatives), periode avril-septembre 2020, 12 fenetres de 15 jours. Y = nombre de nouveaux cas COVID-19 par periode de 15 jours, converti en incidence pour 10000 habitants, transformation logarithmique. 33 VARIABLES CANDIDATES EXHAUSTIVES identifiees (Figure 2 du papier), groupees en 6 categories : (a) Population -- densite de population, population par groupe d'age (0-9/10-19/20-64/65+), nombre de familles classiques, dimension des familles classiques, indice de dependance ; (b) Socio-economique -- emploi par secteur (agriculture/industrie/infrastructure/services), remuneration moyenne, taux de chomage, population illettree, population avec/sans enseignement superieur, taux d'abandon scolaire, pouvoir d'achat par habitant, pensionnes securite sociale en age actif, retraits aux distributeurs ; (c) Habitation -- logements familiaux classiques, logements avec tout confort, logements occupes, logements surpeuples/collectifs/non-classiques, densite de logements, nombre de quartiers sociaux ; (d) Mobilite -- duree moyenne des trajets domicile-travail en transport individuel, mobilite en transport prive/collectif (interne/externe), proportion d'usage de la voiture ; (e) Sante -- existence de services d'urgence de base/permanents/etendus ; (f) Environnement -- temperature moyenne et precipitation totale (source E-OBS, Cornes et al. 2018), emissions de polluants. Apres diagnostic de multicollinearite (VIF>2.5 retire), 16 variables retenues pour l'analyse finale (modele GLMM distribution Tweedie, effet aleatoire NUTS-3). Covariables significatives confirmees 'de facon consistante dans le temps' : pourcentage d'emploi dans les services, temps de trajet moyen en transport individuel, pourcentage d'emploi agricole, taille moyenne des familles. AUCUNE DE CES 33 VARIABLES INE/E-OBS N'EST PRESENTE dans le depot Zenodo local (dgs_data_concelhos_new.csv contient uniquement population/densite/incidence, source DGS pas INE) -- tentative de recuperation directe des donnees PORDATA (base de statistiques municipales portugaises certifiees, https://www.pordata.pt) : lien de telechargement direct teste, retourne HTTP 404 (URL expiree), non poursuivi. formula_used (population + densidade_populacional) reste donc une proposition du curateur, dans l'esprit de la litterature confirmee (densite demographique = categorie 'Population' du papier) mais tres partielle face aux 16 variables retenues du vrai modele. CSV original (dgs_data_concelhos_new.csv) telecharge directement depuis Zenodo -- pas une reconstruction, panel journalier des 308 concelhos portugais. Geometrie jointe a la couche publique geoBoundaries PRT/ADM2 (CC0), 298/308 concelhos apparies (96.8%), N=20604 observations. package_include laisse en manual_review : papier et structure exacte du modele desormais entierement documentes, mais les vraies covariables INE/E-OBS restent hors de portee sans acces direct a un portail de donnees municipales portugaises fonctionnel.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: incidencia ~ population + densidade_populacional
- License evidence: DataCite API record for DOI 10.5281/zenodo.11222023 (checked 2026-08-18): rightsList = 'GNU General Public License v3.0 or later'.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: population, densidade_populacional
- y_term_used: incidencia
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "incidencia ~ population + densidade_populacional"
    response: "incidencia (taux d'incidence COVID-19 standardise sur 14 jours, par concelho) -- le papier utilise en realite le nombre de cas par periode de 15 jours, converti en incidence pour 10000 habitants, log-transforme"
    predictors: ["population (population totale du concelho)", "densidade_populacional (densite de population, hab/km2) -- confirmee dans la categorie 'Population' des 33 variables candidates du papier"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "incidencia ~ population + densidade_populacional + population_65_mais"
    response: "incidencia"
    predictors: ["population", "densidade_populacional", "population_65_mais"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gwr", "sar_lag", "random_forest_xy", "gam_spatial"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_portugal_covid_municipal`
- Dataset name: dgs
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial correlates of COVID-19 first wave across continental Portugal
- Paper DOI: 10.4081/gh.2022.1073
- Dataset DOI: 10.5281/zenodo.11222023
- Source URL: https://doi.org/10.5281/zenodo.11222023
- Year: 2022

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "log(cases_per_10k_15days) ~ pct_emploi_services + temps_trajet_moyen_individuel + pct_emploi_agricole + taille_moyenne_famille + [12 autres variables retenues sur 33 candidates, VIF<2.5] [Barbosa, Silva, Capinha, Garcia & Rocha (2022), 'Spatial correlates of COVID-19 first wave across continental Portugal', Geospatial Health 17(s1):1073, doi:10.4081/gh.2022.1073, texte integral lu (PDF telecharge depuis repositorio.ulisboa.pt, licence CC-BY-NC 4.0). GLMM distribution Tweedie avec effet aleatoire NUTS-3, sur N=278 municipalites (Portugal continental, Acores/Madere exclus faute de donnees), 12 modeles separes (un par periode de 15 jours, avril-septembre 2020). 33 variables candidates en 6 categories (population, socio-economique, habitat, mobilite, sante, environnement -- source principale INE/Statistics Portugal + E-OBS pour temperature/precipitation), reduites a 16 apres diagnostic de multicollinearite (VIF>2.5 retire)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "REVISE x2 (session 2026-08-16 ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : (1) papier trouve et confirme -- Barbosa, Silva, Capinha, Garcia & Rocha (2022), 'Spatial correlates of COVID-19 first wave across continental Portugal', Geospatial Health 17(s1):1073, doi:10.4081/gh.2022.1073. (2) TEXTE INTEGRAL LU (recherche web demandee par l'utilisateur, PDF en libre acces telecharge depuis le depot institutionnel repositorio.ulisboa.pt, CC-BY-NC 4.0) : etude sur N=278 municipalites du Portugal continental (Acores et Madere exclus, donnees indisponibles pour plusieurs variables explicatives), periode avril-septembre 2020, 12 fenetres de 15 jours. Y = nombre de nouveaux cas COVID-19 par periode de 15 jours, converti en incidence pour 10000 habitants, transformation logarithmique. 33 VARIABLES CANDIDATES EXHAUSTIVES identifiees (Figure 2 du papier), groupees en 6 categories : (a) Population -- densite de population, population par groupe d'age (0-9/10-19/20-64/65+), nombre de familles classiques, dimension des familles classiques, indice de dependance ; (b) Socio-economique -- emploi par secteur (agriculture/industrie/infrastructure/services), remuneration moyenne, taux de chomage, population illettree, population avec/sans enseignement superieur, taux d'abandon scolaire, pouvoir d'achat par habitant, pensionnes securite sociale en age actif, retraits aux distributeurs ; (c) Habitation -- logements familiaux classiques, logements avec tout confort, logements occupes, logements surpeuples/collectifs/non-classiques, densite de logements, nombre de quartiers sociaux ; (d) Mobilite -- duree moyenne des trajets domicile-travail en transport individuel, mobilite en transport prive/collectif (interne/externe), proportion d'usage de la voiture ; (e) Sante -- existence de services d'urgence de base/permanents/etendus ; (f) Environnement -- temperature moyenne et precipitation totale (source E-OBS, Cornes et al. 2018), emissions de polluants. Apres diagnostic de multicollinearite (VIF>2.5 retire), 16 variables retenues pour l'analyse finale (modele GLMM distribution Tweedie, effet aleatoire NUTS-3). Covariables significatives confirmees 'de facon consistante dans le temps' : pourcentage d'emploi dans les services, temps de trajet moyen en transport individuel, pourcentage d'emploi agricole, taille moyenne des familles. AUCUNE DE CES 33 VARIABLES INE/E-OBS N'EST PRESENTE dans le depot Zenodo local (dgs_data_concelhos_new.csv contient uniquement population/densite/incidence, source DGS pas INE) -- tentative de recuperation directe des donnees PORDATA (base de statistiques municipales portugaises certifiees, https://www.pordata.pt) : lien de telechargement direct teste, retourne HTTP 404 (URL expiree), non poursuivi. formula_used (population + densidade_populacional) reste donc une proposition du curateur, dans l'esprit de la litterature confirmee (densite demographique = categorie 'Population' du papier) mais tres partielle face aux 16 variables retenues du vrai modele. CSV original (dgs_data_concelhos_new.csv) telecharge directement depuis Zenodo -- pas une reconstruction, panel journalier des 308 concelhos portugais. Geometrie jointe a la couche publique geoBoundaries PRT/ADM2 (CC0), 298/308 concelhos apparies (96.8%), N=20604 observations. package_include laisse en manual_review : papier et structure exacte du modele desormais entierement documentes, mais les vraies covariables INE/E-OBS restent hors de portee sans acces direct a un portail de donnees municipales portugaises fonctionnel."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "CORRECTION 2026-09-09 : verifie -- incidencia est un indicateur officiel DGS (taux d'incidence a 14 jours, casos_14dias/confirmados_14 presents dans le RDS), pas un calcul reconstruit par le pipeline ; aucune ambiguite de denominateur. N/T deja documente (2026-08-17) : 303 unites spatiales distinctes, panel equilibre T=68. Le '278' du papier Barbosa et al. designe leur propre echantillon analytique restreint (variables INE/E-OBS non disponibles localement), sans rapport avec le N=303 de ce depot DGS local -- pas une contradiction. formula_used (population + densidade_populacional) reste un proxy partiel honnete du vrai modele a 16 variables du papier (variables INE/E-OBS non recuperables, tentative PORDATA documentee en echec HTTP 404) -- estimateurs en base generated_candidate en consequence."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: CORRECTION 2026-09-09 : verifie -- incidencia est un indicateur officiel DGS (taux d'incidence a 14 jours, casos_14dias/confirmados_14 presents dans le RDS), pas un calcul reconstruit par le pipeline ; aucune ambiguite de denominateur. N/T deja documente (2026-08-17) : 303 unites spatiales distinctes, panel equilibre T=68. Le '278' du papier Barbosa et al. designe leur propre echantillon analytique restreint (variables INE/E-OBS non disponibles localement), sans rapport avec le N=303 de ce depot DGS local -- pas une contradiction. formula_used (population + densidade_populacional) reste un proxy partiel honnete du vrai modele a 16 variables du papier (variables INE/E-OBS non recuperables, tentative PORDATA documentee en echec HTTP 404) -- estimateurs en base generated_candidate en consequence.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: generated_candidate
      source_ref: "Proxy partiel du modele publie (GLMM Tweedie a 16 variables, Barbosa et al. 2022) -- seules population/densite (categorie 'Population' du papier) sont disponibles localement."
      notes: "Approximation tres partielle -- 2 covariables sur 16 du modele reel."
    - estimator: gam_spatial
      basis: generated_candidate
      source_ref: "Meme reserve que ols -- approximation non-lineaire generique."
      notes: "Idem -- proxy partiel, pas le modele publie."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Aucune -- comparateur ML generique, Y continu."
      notes: "Comparateur ML, pas le modele publie."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs eligibles comme proxy partiel documente (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 20604
- k variables: 34
- T periods: 68
- Variable temporelle: data
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (20604) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 303 ; panel EQUILIBRE (chaque unite a exactement T=68 observations). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 303 unites spatiales distinctes, pas sur les 20604 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT (source native : MULTIPOLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- Spatial resolution: point observation
- Temporal resolution: 68 distinct periods (variable: data)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-31.2297526962874, -6.31095534679191], y [32.68701355, 42.0597907]
- Time range: 01-07-2021 to 31-03-2021 (variable: data)
- CRS analyse recommande: pending — multi-zones (span=24.9deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

## Bloc 6 - Reproductibilite

- License present: yes
- License name: GNU General Public License v3.0 or later
- License URL: https://www.gnu.org/licenses/gpl-3.0-standalone.html
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`portugal_covid_municipal` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `portugal_covid_municipal` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: tendencia_incidencia (NA=97.1%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`portugal_covid_municipal` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial correlates of COVID-19 first wave across continental Portugal

## Curation documentée — 2026-09-07

Decision conservatoire : Panel municipal de 20 604 lignes; 278 désigne un nombre de communes dans le texte, pas nécessairement une contradiction sur N. Distinguer N lignes/N communes/T, vérifier dénominateur et période d’incidence, puis agrégation ou CV temporelle/groupée. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
